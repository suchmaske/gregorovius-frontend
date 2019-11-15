<template>
  <div class="q-pa-md">
    <q-select
      ref="selector"
      v-model="model"
      filled
      bg-color="white"
      use-input
      hide-selected
      fill-input
      :options="options"
      :label="label"
      :value="this.model.value"
      @filter="filterFn"
      @input="setSelected"
    >
      <template v-if="model.value !== ''" v-slot:append>
        <q-icon
          name="cancel" class="cursor-pointer" 
          @click.stop="model = {label: '', value: ''}; setSelected()" 
        />
      </template>
    </q-select>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  name: 'SelectAutoComplete',
  props: ['label', 'entity'],
  data() {
    return {
      model: {
        label: '',
        value: ''
      },
      options: this.$attrs.options,
      hideSelected: true,
      useInput: true
    };
  },
  beforeDestroy() {
    this.getSelected()
  },
  methods: {
    ...mapActions(['setSelectedAction']),
    filterFn(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        const options = this.optionsFull.filter(o => o.label.toLowerCase().indexOf(needle) > -1);
        this.options = options.sort((a, b) => {
          const valA = a.label.toLowerCase();
          const valB = b.label.toLowerCase();
          return (valA < valB) ? -1 : (valA > valB) ? 1 : 0;
        });
      });
    },
    setSelected() {
      this.setSelectedAction({ entity: this.$props.entity, value: this.value });
    },
    getSelected() {
      const toTitleCase = s => 'selected' + s.substr(0, 1).toUpperCase() + s.substr(1); 
      const key = toTitleCase(this.$props.entity)
      const selectedId = this.$store.getters[key]
      if (selectedId != "") {
        return this.optionsFull.find(pair => {return pair.value === selectedId})
      }
    },
  },
  computed: {
    optionsFull() {
      return this.$attrs.options;
    },
    value() {
      return this.model.value;
    },
  },
};
</script>

<style>
</style>
