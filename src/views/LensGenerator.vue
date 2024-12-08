<template>
  <form class="max-w-50 max-w-xs mx-auto" @submit.prevent>
    <legend class="text-lg">Lens Adapter Generator</legend>

    <label class="form-control" v-if="data">
      <label class="label cursor-pointer">Male Mount</label>
      <select class="select select-bordered" v-model="maleMount">
        <optgroup v-for="(mounts, brand) in data.male" :key="brand" :label="brand">
          <option v-for="mount in mounts" :key="`male/${brand}/${mount.name}`" :value="mount">
            {{ mount.name }}
          </option>
        </optgroup>
      </select>
      <div class="label">
        <span class="label-text-alt">The end that goes into the camera body, usually</span>
      </div>
      <div class="label" v-if="maleMount && maleMount.attribution_text">
        <span class="label-text-alt" v-if="maleMount.attribution_link">
          <a :href="maleMount.attribution_link" class="link">{{ maleMount.attribution_text }}</a>
        </span>
        <span class="label-text-alt" v-else>
          {{ femaleMount.attribution_text }}
        </span>
      </div>
    </label>
    <div class="form-control">
      <label class="label cursor-pointer">Female Mount</label>
      <select class="select select-bordered" v-model="femaleMount">
        <optgroup v-for="(mounts, brand) in data.female" :key="brand" :label="brand">
          <option v-for="mount in mounts" :key="`female/${brand}/${mount.name}`" :value="mount">
            {{ mount.name }}
          </option>
        </optgroup>
      </select>
      <div class="label">
        <span class="label-text-alt">The end that goes into the lens, usually</span>
      </div>
      <div class="label" v-if="femaleMount && femaleMount.attribution_text">
        <span class="label-text-alt" v-if="femaleMount.attribution_link">
          <a :href="femaleMount.attribution_link" class="link">{{ femaleMount.attribution_text }}</a>
        </span>
        <span class="label-text-alt" v-else>
          {{ femaleMount.attribution_text }}
        </span>
      </div>
    </div>
    <GeneratorForm :scad-file="scadFile" :output-name="outputName" :scad-resources="resources" :scad-variables="options"
      :model-options="modelOptions" />
    <!-- <p class="mt-3 italic text-sm">
      These plates are based on the work of
      <a class="link" href="https://github.com/rdmullett/voron_serial_plate" target="_blank">rdmullett</a>
      and
      <a class="link" href="https://www.thingiverse.com/thing:4947518" target="_blank">oldfartt</a>.
    </p> -->
  </form>
</template>

<script setup lang="ts">
import GeneratorForm from '@/components/GeneratorForm.vue'
import { reactive, computed, ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const data = ref({})

const maleMount = ref()
const femaleMount = ref()

const scadFile = { url: 'scad/generator.scad', name: 'adapter.scad' }

const maleMountName = computed(() => {
  if (!maleMount.value) return ''
  return `male/${maleMount.value.file.split('/').pop()}`
})
const femaleMountName = computed(() => {
  if (!femaleMount.value) return ''
  return `female/${femaleMount.value.file.split('/').pop()}`
})

const cone_height = computed(() => {
  if (!maleMount.value || !femaleMount.value) return 0
  return femaleMount.value.flange - maleMount.value.flange - maleMount.value.thickness - femaleMount.value.thickness
})
const resources = computed(() => {
  if (!data.value) return []
  const resources = []
  if (maleMount.value && femaleMount.value) {
    resources.push(
      { url: `models/male/${maleMount.value.file}`, name: maleMountName.value },
      { url: `models/female/${femaleMount.value.file}`, name: femaleMountName.value }
    )
  }
  return resources
})
const options = computed(() => ({
  cone_height: cone_height.value,
  cone_male_diameter: maleMount.value?.diameter || 10,
  cone_female_diameter: femaleMount.value?.diameter || 10,
  wall_thickness: 6,
  segment_count: 100,
  male_mount: maleMountName.value,
  female_mount: femaleMountName.value,
}))
const modelOptions = reactive({
  color: '#cc000e'
})
const outputName = computed(
  () => `Voron_${!options.logo ? 'No_' : ''}Logo_Plate_${options.serial}.stl`
)

onMounted(async () => {
  try {
    const response = await fetch('/data.json')
    if (!response.ok) {
      throw new Error('Network response was not ok')
    }
    data.value = await response.json()
  } catch (error) {
    console.error('Error fetching data:', error)
  }
})
</script>

<style></style>
