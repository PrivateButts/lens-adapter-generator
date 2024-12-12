<template data-theme="voron">
  <form class="max-w-50 max-w-xs mx-auto">
    <legend>Voron Plate Generator</legend>
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
          The current plate model accommodates up to 7 characters properly
        </span>
      </div>
    </label>
    <div class="form-control">
      <label class="label cursor-pointer">
        <span class="label-text">Include Logo:</span>
        <input type="checkbox" v-model="options.logo" class="checkbox checkbox-primary" />
      </label>
    </div>
    <GeneratorForm
      :scad-file="scadFile"
      :output-name="outputName"
      :scad-resource-urls="resources"
      :scad-variables="options"
    />
  </form>
</template>

<script setup lang="ts">
import GeneratorForm from '@/components/GeneratorForm.vue'
import { reactive, computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const scadFile = { url: 'scad/voron/Voron_Logo_Plate.scad', name: 'plate.scad' }
const resources = [
  { url: 'scad/voron/Serial_Plate_Voron_Logo.stl', name: 'Serial_Plate_Voron_Logo.stl' },
  { url: 'scad/voron/Serial_Plate_Voron_NoLogo.stl', name: 'Serial_Plate_Voron_NoLogo.stl' },
  { url: 'scad/voron/Play.ttf', name: 'fonts/Play.ttf' }
]
const options = reactive({
  font1: 'Play',
  serial: route.query.serial || 'VX.XXXX',
  logo: true
})
const outputName = computed(
  () => `Voron_${!options.logo ? 'No_' : ''}Logo_Plate_${options.serial}.stl`
)
</script>

<style></style>
