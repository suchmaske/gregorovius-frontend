<template>
  <div class="q-pa-md">
    <div class="q-gutter-md row">
      <q-select
        filled
        bg-color="white"
        v-model="model"
        use-input
        hide-selected
        fill-input
        input-debounce="0"
        :options="options"
        :label="label"
        @filter="filterFn"
        @input="setSelected"
        map-options
        ref="selector"
        :value="this.model.value"
      >
        <template v-slot:no-option>
          <q-item>
            <q-item-section class="text-grey">
              Keine Ergebnisse
            </q-item-section>
          </q-item>
        </template>
      </q-select>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: 'SelectAutoComplete',
  props: ['label', 'entity'],
  data () {
    return {
        model: {
          label: '',
          value: ''
        },
        options: this.$attrs.options,
    }
  },
  methods: {
    ...mapActions(['setSelectedAction']),
    filterFn (val, update, abort) {
      update(() => {
        const needle = val.toLowerCase()
        const options = this.optionsFull.filter(o => o.label.toLowerCase().indexOf(needle) > -1 )
        this.options = options.sort((a, b) => {
          const valA = a.label.toLowerCase()
          const valB = b.label.toLowerCase()
          return (valA < valB) ? -1 : (valA > valB) ? 1 : 0
        })
      })
    },
    setSelected () {
      this.setSelectedAction({entity: this.$props.entity, value: this.value})
    },
  },
  computed: {
    optionsFull () {
      return this.$attrs.options
    },
    value () {
      return this.model.value
    }
  }
};
</script>

<style>
</style>