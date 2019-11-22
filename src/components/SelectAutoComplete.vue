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
      model: {},
      options: this.$attrs.options,
    };
  },
  async mounted () {
    await this.getSelected()
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
      this.model = this.$store.getters["selected" + this.$props.entity[0].toUpperCase() + this.$props.entity.slice(1)]
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
