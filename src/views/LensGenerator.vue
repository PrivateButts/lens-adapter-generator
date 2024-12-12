<template>
  <form class="max-w-50 max-w-lg mx-auto" @submit.prevent>
    <legend class="text-lg">Lens Adapter Generator</legend>

    <label class="form-control" v-if="data && data.male">
      <label class="label cursor-pointer">Male Mount</label>
      <select class="select select-bordered" v-model="maleMount">
        <optgroup v-for="(mounts, brand) in Object.groupBy(data.male, ({ group }) => group)" :key="brand"
          :label="brand">
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
          {{ maleMount.attribution_text }}
        </span>
        <span class="label-text-alt" v-if="maleMount.license">
          Licensed under
          <a :href="licenseLink(maleMount.license)" target="_blank" class="link">
            {{ maleMount.license }}
          </a>
        </span>
      </div>
    </label>
    <label class="form-control" v-if="data && data.female">
      <label class="label cursor-pointer">Female Mount</label>
      <select class="select select-bordered" v-model="femaleMount">
        <optgroup v-for="(mounts, brand) in Object.groupBy(data.female, ({ group }) => group)" :key="brand"
          :label="brand">
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
        <span class="label-text-alt" v-if="femaleMount.license">
          Licensed under
          <a :href="licenseLink(femaleMount.license)" target="_blank" class="link">
            {{ femaleMount.license }}
          </a>
        </span>
      </div>
    </label>
    <div role="alert" class="alert alert-error" v-if="maleMount && cone_height < 1 - maleMount.thickness">
      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0 stroke-current" fill="none" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
          d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
      <span>Connecting distance between mounts is more negative than the thickness of the male mount. The generated
        model will probably not work without significant editing or may not be possible at all.</span>
    </div>
    <div role="alert" class="alert alert-warning" v-else-if="cone_height < 0">
      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0 stroke-current" fill="none" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
          d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
      </svg>
      <span>The connecting distance between mounts is negative, but less than the thickness of the male mount. The
        generated model will have clipping, but could potentially be usable.</span>
    </div>
    <GeneratorForm :scad-file="scadFile" :output-name="outputName" :scad-resources="resources" :scad-variables="options"
      :model-options="modelOptions" :forceDisabled="!(maleMount && femaleMount)" />

    <div tabindex="0" class="collapse collapse-arrow border-base-300 bg-base-200 border mt-4"
      v-if="maleMount && femaleMount">
      <div class="collapse-title text-sm font-medium">Click here for some numbers</div>
      <div class="collapse-content">
        <table class="table">
          <thead>
            <tr>
              <th>Variable</th>
              <th>Value</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Female (goal) <span title="Flange Focal Distance">FFD</span></td>
              <td class="text-right">{{ femaleMount.flange }} mm</td>
            </tr>
            <tr>
              <td>Male <span title="Flange Focal Distance">FFD</span></td>
              <td class="text-right">{{ maleMount.flange }} mm</td>
            </tr>
            <tr>
              <td>Calculated Connector Distance</td>
              <td class="text-right">{{ cone_height }} mm</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    <div class="mt-4 prose">
      <h1 class="text-xl">What is this?</h1>
      <p>This tool takes premade models of camera mounts and stitches them together via a dynamically generated hollow
        cone
        shape. The resultant models should work as a quick and dirty adapter, but are not as optimized as an adapter
        designed from scratch by a human. Keep in mind that none of these models are guaranteed to work or have been
        tested.
        If you do print one out, and it does work,
        <a href="https://github.com/PrivateButts/lens-adapter-generator/issues/new?assignees=&labels=test+report&projects=&template=testing_report.md&title=%5Btest%5D+"
          target="_blank" class="link">
          lemme know here</a>
        and I'll mark it as tested whenever I release an update.
        If you have a mount that you'd like to contribute,
        <a href="https://github.com/PrivateButts/lens-adapter-generator/issues/new?assignees=&labels=mount+request&projects=&template=mount_request.md&title=%5Bmount%5D+"
          target="_blank" class="link">
          submit
          a request here</a>. Otherwise, if one of these adapters
        helps
        you, be sure to support the creators who's mounts were used to make it.
      </p>
    </div>
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
  cone_male_inner_diameter: maleMount.value?.inner_diameter || 10,
  cone_male_outer_diameter: maleMount.value?.outer_diameter || 10,
  cone_female_inner_diameter: femaleMount.value?.inner_diameter || 10,
  cone_female_outer_diameter: femaleMount.value?.outer_diameter || 10,
  segment_count: 100,
  male_mount: maleMountName.value,
  female_mount: femaleMountName.value,
}))
const modelOptions = reactive({
  color: '#cc000e'
})
const outputName = computed(
  () => {
    if (!maleMount.value || !femaleMount.value) return ''
    return `${femaleMount.value.group} ${femaleMount.value.name} to ${maleMount.value.group} ${maleMount.value.name} Adapter.stl`
  }
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

const licenseLink = (license: string) => {
  if (!license) return '#'
  return `https://spdx.org/licenses/${license}.html`
}
</script>

<style></style>
