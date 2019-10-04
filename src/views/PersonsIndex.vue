<template>
  <q-page padding>
    <div class="q-pa-md">
      <q-table
        :data="data"
        :columns="columns"
        row-key="id"
        :filter="filter"
        :pagination.sync="pagination"
        :loading="loading"
        flat
      >
        <template v-slot:body-cell="props">
          <q-td :props="props" @click.native="$router.push({ path: `/persons/${props.row.id}` })" class="cursor-pointer">{{ props.value }}</q-td>
        </template>
        <template v-slot:top-left>
          <q-input borderless dense debounce="300" v-model="filter" placeholder="Suche">
            <template v-slot:append>
              <q-icon name="search" />
            </template>
          </q-input>
        </template>
      </q-table>
    </div>
  </q-page>
</template>

<script>

export default {
  name: 'items-list',
  data() {
    return {
      filter: '',
      loading: true,
      pagination: {
        rowsPerPage: 10,
        sortBy: 'name',
      },
      columns: [
        {
          name: 'name',
          required: true,
          label: 'Name',
          align: 'left',
          field: row => this.formatName(row.properties.name),
          sortable: true,
        },
      ],
      data: [],
    };
  },

  mounted() {
    this.getItems();
  },

  methods: {
    async getItems() {
      try {
        const response = await fetch(`http://localhost:8000${this.$route.path}`);
        const data = await response.json();
        this.data = data;
        this.loading = false;
      } catch (error) {
        // eslint-disable-next-line
        console.error(error)
      }
    },
    formatName(name) {
      if (name.surname && name.forename) {
        return `${name.forename} ${name.surname}`;
      } if (name.forename) {
        return name.forename;
      } if (name.surname) {
        return name.surname;
      } if (name.simpleName) {
        return name.simpleName;
      } if (name.roleName && name.simpleName) {
        return `${name.simpleName}, ${name.roleName}`;
      } if (name.roleName && name.forename) {
        return `${name.forename}, ${name.roleName}`;
      } if (name.orgName) {
        return name.orgName;
      }
      return 'NN';
    },
  },

};
</script>

<style>
</style>
