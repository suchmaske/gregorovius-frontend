<template>
  <div class="q-pa-md">
      <q-select
        filled
        bg-color="white"
        multiple
        use-input
        fill-input
        v-model="model"
        :options="options"
        :label="label"
        :value="this.model"
      >
        <template v-slot:option="scope">
          <q-item>
            <q-item-section>
              <q-item-label v-html="scope.opt" ></q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-toggle v-model="model" :val="scope.opt" @input="setSelected"/>
            </q-item-section>
          </q-item>
        </template>
      </q-select>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  name: 'SelectYears',
  props: ['label', 'entity'],
  data() {
    return {
      model: [],
    };
  },
  methods: {
    ...mapActions(['setSelectedAction']),
    setSelected() {
      this.setSelectedAction({ entity: this.$props.entity, value: this.model });
    },
  },
  computed: {
    options() {
      return this.$attrs.options;
    },
  },
};
</script>

<style>
</style>
