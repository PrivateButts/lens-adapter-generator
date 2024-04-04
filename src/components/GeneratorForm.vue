<template>
  <div>
    <button @click="generateBtnHandler" :disabled="generating">Generate</button>
  </div>
  <div v-if="generating">Generating...</div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
// import useOpenSCAD, { type OpenSCAD } from '@/lib/openscad-wasm/openscad'
// OPTIONAL: add fonts to the FS
// import { addFonts } from '@/lib/openscad-wasm/openscad.fonts'
// OPTIONAL: add MCAD liibrary to the FS
// import { addMCAD } from '@/lib/openscad-wasm/openscad.mcad'
import useOpenSCAD from '@/lib/alt-wasm/openscad'

interface SCADResource {
  name: string
  url: string
}

const props = defineProps<{
  scadFile: SCADResource
  outputName: string
  scadResourceUrls?: SCADResource[]
  scadVariables?: Record<string, any>
}>()

const scadInstance = ref<OpenSCAD>()
const resourceDatas = ref<Record<string, string | ArrayBufferView>>({})
const generating = ref(false)
const prepped = ref(false)

onMounted(async () => {
  fetchResource(props.scadFile)
  if (props.scadResourceUrls) {
    await Promise.all(props.scadResourceUrls.map(fetchResource))
  }
})

const fetchResource = async (resource: SCADResource) => {
  const response = await fetch(resource.url)
  if (!response.ok) {
    throw new Error(`Failed to fetch ${resource.url}`)
  }
  const data = await response.arrayBuffer()
  resourceDatas.value[resource.name] = new Uint8Array(data)
}

const prepFS = async () => {
  if (!scadInstance.value) return
  if (Object.keys(resourceDatas.value).length < (props.scadResourceUrls?.length || 0) + 1) return

  console.debug('prepping FS')

  scadInstance.value.FS.mkdir('/fonts')
  scadInstance.value.FS.writeFile(props.scadFile.name, resourceDatas.value[props.scadFile.name])
  if (props.scadResourceUrls) {
    props.scadResourceUrls.forEach((resource) => {
      if (resourceDatas.value[resource.name]) {
        scadInstance.value!.FS.writeFile(resource.name, resourceDatas.value[resource.name])
      }
    })
  }

  prepped.value = true
}

const generateBtnHandler = async () => {
  generating.value = true
  try {
    await generate()
  } catch (e) {
    console.error(e)
  }
  generating.value = false
}

const generate = async () => {
  const wasmMemory = new WebAssembly.Memory({ initial: 16384, maximum: 16384 })
  scadInstance.value = await useOpenSCAD({
    wasmMemory,
    buffer: wasmMemory && wasmMemory.buffer,
    noInitialRun: true,
    print: (text: string) => {
      console.debug('stdout: ' + text)
    },
    printErr: (text: string) => {
      console.debug('stderr: ' + text)
    }
  })
  prepFS()

  console.debug(scadInstance)
  let cmd = [`/${props.scadFile.name}`]
  if (props.scadVariables) {
    for (const [key, value] of Object.entries(props.scadVariables)) {
      cmd.push('-D', `${key}="${value}"`)
    }
  }
  cmd.push('-o', 'output.stl')
  scadInstance.value.callMain(cmd)

  // Read the data from cube.stl
  const output = scadInstance.value.FS.readFile('/output.stl')

  const aElement = document.createElement('a')
  aElement.setAttribute('download', props.outputName)
  const href = URL.createObjectURL(new Blob([output]))
  aElement.href = href
  aElement.setAttribute('target', '_blank')
  aElement.click()
  URL.revokeObjectURL(href)
  aElement.remove()

  scadInstance.value.FS.unlink('/output.stl')
}
</script>
