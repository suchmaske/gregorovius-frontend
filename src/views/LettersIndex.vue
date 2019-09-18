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
        bordered
      >
        <template v-slot:body-cell="props">
          <q-td :props="props" @click.native="$router.push({ path: `/letters/${props.row.id}` })" class="cursor-pointer">{{ props.value }}</q-td>
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
  data () {
    return {
      filter: '',
      loading: true,
      pagination: {
        rowsPerPage: 10
      },
      columns: [
        {
          name: 'recipient',
          required: true,
          label: 'Empfänger',
          align: 'left',
          field: row => this.getNames(row.properties.recipient),
          format: val => val.join(', '),
          sortable: true
        },
        {
          name: 'date',
          required: true,
          label: 'Datum',
          align: 'left',
          field: row => (row.properties.date ? new Date(row.properties.date) : null),
          format: val => (val ? val.toLocaleDateString('de-DE', {
            day: 'numeric', month: 'long', year: 'numeric'
          }) : "o. D."),
          sortable: true
        },
        {
          name: 'title',
          required: true,
          label: 'Titel',
          align: 'left',
          field: row => row.properties.title,
          sortable: false
        }
      ],
      data: [],
      persList: [],
      orgList: [],
      placeList: [],
    }
  },

  beforeMount () {
    [
      this.getItems('/persons', 'persList'),
      this.getItems('/institutions', 'orgList'),
      this.getItems('/places', 'placeList'),
    ]
  },

  mounted () {
    this.getItems(this.$route.path, 'data')
  },

  methods: {
    async getItems (source, target) {
      try {
        const response = await fetch('http://localhost:8000' + source)
        const data = await response.json()
        this[target] = data
        this.loading = false
      } catch (error) {
        // eslint-disable-next-line
        console.error(error)
      }
    },
    getName (id) {
      var items = [...this.persList, ...this.orgList]
      var item = items.find(x => x.id === id)
      if (item.properties.name) {
        var name = item.properties.name
      } else {
        var name = null
      }
      if (name.surname && name.forename) {
        return `${name.forename} ${name.surname}`
      } else if (name.simpleName) {
        return name.simpleName
      } else if (name.roleName && name.simpleName) {
        return `${name.simpleName}, ${name.roleName}`
      } else if (name.roleName && name.forename) {
        return `${name.forename}, ${name.roleName}`
      } else if (name.orgName) {
        return name.orgName
      } else {
        return "NN"
      }
    },
    getNames (idList) {
      if (idList) {
        return idList.map(this.getName)
      } else {
        return ["NN"]
      }

    }
  },

}
</script>

<style>
</style>
