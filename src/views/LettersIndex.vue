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
          field: row => row.properties.recipient[0],
          sortable: true
        },
        {
          name: 'date',
          required: true,
          label: 'Datum',
          align: 'left',
          field: row => row.properties.date,
          format: val => new Date(val).toLocaleDateString('de-DE', {
            day: 'numeric', month: 'long', year: 'numeric'
          }),
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
      persList: []
    }
  },

  beforeMount () {
    this.getPersons()
  },

  mounted () {
    this.getItems()
  },

  methods: {
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
    },
    async getPersons () {
        try {
          const persResponse = await fetch('http://localhost:8000/persons')
          const persData = await persResponse.json()
          this.persList = persData
        } catch (error) {
          // eslint-disable-next-line
          console.error(error)
        }
    },

    fullName (id) {
      var person = this.persList.find(x => x.id === id)
      if (person) {
        return person.properties.name.forename + ' ' + person.properties.name.surname
      } else {
        return ''
      }
    }
  },

  computed: {
    fullName () {
      return 'test'
    }
  }

}
</script>

<style>
</style>
