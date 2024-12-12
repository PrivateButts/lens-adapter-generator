<template>
  <div>
    <h1>Voron Plate Generator</h1>
    <div>Serial Number: <input type="text" v-model="options.serial" /></div>
    <div>Logo: <input type="checkbox" v-model="options.logo" /></div>
    <GeneratorForm
      :scad-file="scadFile"
      :output-name="outputName"
      :scad-resource-urls="resources"
      :scad-variables="options"
    />
  </div>
</template>

<script setup lang="ts">
import GeneratorForm from '@/components/GeneratorForm.vue'
import { reactive, computed } from 'vue'

const scadFile = { url: 'scad/voron/Voron_Logo_Plate.scad', name: 'plate.scad' }
const resources = [
  { url: 'scad/voron/Serial_Plate_Voron_Logo.stl', name: 'Serial_Plate_Voron_Logo.stl' },
  { url: 'scad/voron/Serial_Plate_Voron_NoLogo.stl', name: 'Serial_Plate_Voron_NoLogo.stl' },
  { url: 'scad/voron/Play.ttf', name: 'fonts/Play.ttf' }
]
const options = reactive({
  font1: 'Play',
  serial: 'VX.XXX',
  logo: true
})
const outputName = computed(
  () => `Voron_${!options.logo ? 'No_' : ''}Logo_Plate_${options.serial}.stl`
)
</script>

<style></style>
