<template>
  <form class="max-w-50 max-w-xs mx-auto" @submit.prevent>
    <legend class="text-lg">Voron Plate Generator</legend>
    <label class="form-control w-full max-w">
      <div class="label">
        <span class="label-text">Serial Number:</span>
      </div>
      <input
        type="text"
        placeholder="VX.XXXX"
        v-model="options.serial"
        class="input input-bordered w-full max-w"
        required
      />
      <div class="label">
        <span class="label-text-alt">
          The current plate models accommodate up to 7 characters properly
        </span>
      </div>
    </label>
    <div class="form-control">
      <label class="label cursor-pointer">Extrusion Size</label>
      <select class="select select-bordered" v-model="extrusionSize">
        <option value="2020">2020 (Voron 2.4)</option>
        <option value="1515">1515 (Voron 0)</option>
      </select>
    </div>
    <div class="form-control my-2">
      <label class="label cursor-pointer">
        <span class="label-text">Include Logo:</span>
        <input type="checkbox" v-model="options.logo" class="checkbox checkbox-primary" />
      </label>
    </div>
    <GeneratorForm
      :scad-file="scadFile"
      :output-name="outputName"
      :scad-resources="resources"
      :scad-variables="options"
      :model-options="modelOptions"
    />
    <p class="mt-3 italic text-sm">
      These plates are based on the work of
      <a class="link" href="https://github.com/rdmullett/voron_serial_plate" target="_blank"
        >rdmullett</a
      >
      and
      <a class="link" href="https://www.thingiverse.com/thing:4947518" target="_blank">oldfartt</a>.
    </p>
  </form>
</template>

<script setup lang="ts">
import GeneratorForm from '@/components/GeneratorForm.vue'
import { reactive, computed, ref } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const extrusionSize = ref('2020')

const scadFile = { url: 'scad/voron/voron.scad', name: 'plate.scad' }
const resources = [
  { url: 'scad/voron/2020logo.stl', name: '2020logo.stl' },
  { url: 'scad/voron/2020logo7.stl', name: '2020logo7.stl' },
  { url: 'scad/voron/2020nologo.stl', name: '2020nologo.stl' },
  { url: 'scad/voron/2020nologo7.stl', name: '2020nologo7.stl' },
  { url: 'scad/voron/1515logo.stl', name: '1515logo.stl' },
  { url: 'scad/voron/1515nologo.stl', name: '1515nologo.stl' },
  { url: 'scad/voron/Play.ttf', name: 'fonts/Play.ttf' }
]
const use1515 = computed(() => extrusionSize.value === '1515')
const options = reactive({
  font1: 'Play',
  serial: route.query.serial || 'VX.XXXX',
  logo: true,
  use1515: use1515
})
const modelOptions = reactive({
  color: '#cc000e'
})
const outputName = computed(
  () => `Voron_${!options.logo ? 'No_' : ''}Logo_Plate_${options.serial}.stl`
)
</script>

<style></style>
