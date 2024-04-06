<template>
  <form class="max-w-50 max-w-xs mx-auto" @submit.prevent>
    <legend class="text-lg">JourneyMaker Plate Generator</legend>
    <p class="my-1 italic text-sm">
      Hey, this is a prototype plate that I'm working on, it's not official in any way.
    </p>
    <label class="form-control w-full max-w">
      <div class="label">
        <span class="label-text">Serial Number:</span>
      </div>
      <input
        type="text"
        placeholder="JM.XXXX"
        v-model="scadOptions.serial"
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
        <input type="checkbox" v-model="scadOptions.logo" class="checkbox checkbox-primary" />
      </label>
    </div>
    <GeneratorForm
      :scad-file="scadFile"
      :output-name="outputName"
      :scad-resources="resources"
      :scad-variables="scadOptions"
      :model-options="modelOptions"
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
const scadOptions = reactive({
  font1: 'Play',
  serial: route.query.serial || 'JM.XXXX',
  logo: true
})
const modelOptions = reactive({
  color: '#0097a7'
})
const outputName = computed(
  () => `JourneyMaker_${!scadOptions.logo ? 'No_' : ''}Logo_Plate_${scadOptions.serial}.stl`
)
</script>

<style></style>
