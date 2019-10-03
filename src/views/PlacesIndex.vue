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
          <q-td :props="props" @click.native="$router.push({ path: `/places/${props.row.id}` })" class="cursor-pointer">{{ props.value }}</q-td>
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

import { mapActions, mapState } from 'vuex'

export default {
  name: 'items-list',
  data () {
    return {
      filter: '',
      loading: true,
      pagination: {
        rowsPerPage: 10,
        sortBy: 'toponym'
      },
      columns: [
        {
          name: 'toponym',
          required: true,
          label: 'Ortsname',
          align: 'left',
          field: row => row.properties.name.toponym,
          sortable: true
        }
      ],
      data: []
    }
  },

  mounted () {
    this.getItems()
  },

  async beforeMount () {
    await this.loadFullNameIndexAction()
  },

  methods: {
    ...mapActions(['loadFullNameIndexAction']),
    async getItems () {
      try {
        const response = await fetch('http://localhost:8000' + this.$route.path)
        const data = await response.json()
        this.data = data
        this.loading = false
      } catch (error) {
        // eslint-disable-next-line
        console.error(error)
      }
    }
  },
  computed: {
    fullNameIndex () {
      return this.$store.getters.fullNameIndex
    },
  }

}
</script>

<style>
</style>
