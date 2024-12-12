<template>
  <div class="px-5 mt-2 mb-5">
    <button @click="generateBtnHandler" :disabled="generating" class="btn btn-block btn-primary">
      Generate
    </button>
  </div>
  <div v-if="generating" class="aspect-w-16 aspect-h-9">
    <div class="w-full">Generating... This tab may freeze for a couple seconds.</div>
  </div>
  <STLViewer
    v-if="!generating && generatedSTL"
    :stlFile="stlDataUrl"
    :modelOptions="{ rotationx: -1.5708, color: '#cc000e' }"
    class="aspect-w-16 aspect-h-9"
  ></STLViewer>
  <div class="px-5 mt-5">
    <button @click="downloadSTL" :disabled="!generatedSTL" class="btn btn-block btn-primary">
      Download STL
    </button>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import useOpenSCAD from '@/lib/alt-wasm/openscad'
import STLViewer from '@/components/STLViewer.vue'
import type { OpenSCAD } from '@/lib/alt-wasm/openscad'

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
const generatedSTL = ref<Blob>()

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
  generatedSTL.value = new Blob([scadInstance.value.FS.readFile('/output.stl')])
}

const downloadSTL = () => {
  if (!generatedSTL.value) return
  const aElement = document.createElement('a')
  aElement.setAttribute('download', props.outputName)
  const href = stlDataUrl.value
  aElement.href = href
  aElement.setAttribute('target', '_blank')
  aElement.click()
  URL.revokeObjectURL(href)
  aElement.remove()
}

const stlDataUrl = computed(() => {
  if (generatedSTL.value) {
    return URL.createObjectURL(generatedSTL.value)
  }
  return ''
})
</script>
