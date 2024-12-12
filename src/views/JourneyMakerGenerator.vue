<template data-theme="JourneyMaker">
  <form class="max-w-50 max-w-xs mx-auto">
    <legend>JourneyMaker Plate Generator</legend>
    <label class="form-control w-full max-w">
      <div class="label">
        <span class="label-text">Serial Number:</span>
      </div>
      <input
        type="text"
        placeholder="JM.XXXX"
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

const scadFile = { url: 'scad/journeymaker/journeymaker.scad', name: 'plate.scad' }
const resources = [
  { url: 'scad/journeymaker/logoplate.stl', name: 'logoplate.stl' },
  { url: 'scad/journeymaker/plate.stl', name: 'plate.stl' },
  { url: 'scad/journeymaker/Play.ttf', name: 'fonts/Play.ttf' }
]
const options = reactive({
  font1: 'Play',
  serial: route.query.serial || 'JM.XXXX',
  logo: true
})
const outputName = computed(
  () => `JourneyMaker_${!options.logo ? 'No_' : ''}Logo_Plate_${options.serial}.stl`
)
</script>

<style></style>
