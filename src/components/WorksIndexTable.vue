<template>
  <q-table
    :data="this.$attrs.data"
    :columns="columns"
    row-key="id"
    :filter="filter"
    :pagination.sync="pagination"
    :loading="loading"
    flat
  >
    <template v-slot:body-cell="props">
      <q-td
        :props="props"
        class="cursor-pointer"
        @click.native="$router.push({ path: `/works/${props.row.id}` })"
        >{{ props.value }}</q-td
      >
    </template>
    <template v-slot:top-left>
      <q-input v-model="filter" borderless dense debounce="300" placeholder="Suche">
        <template v-slot:append>
          <q-icon name="search" />
        </template>
      </q-input>
    </template>
  </q-table>
</template>

<script>
export default {
  name: "WorksIndexTable",
  data() {
    return {
      filter: "",
      loading: this.$store.state.isLoading,
      pagination: {
        rowsPerPage: 10,
        sortBy: "title"
      },
      columns: [
        {
          name: "title",
          required: true,
          label: "Titel",
          align: "left",
          field: row => row.properties.title,
          sortable: true
        }
      ],
      data: []
    };
  },
  beforeMount() {
    this.$store.watch(
      (state, getters) => getters.loading,
      (newValue, oldValue) => {
        this.loading = newValue;
      }
    );
  }
};
</script>

<style></style>
