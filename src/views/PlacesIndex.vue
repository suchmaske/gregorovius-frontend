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
          <q-td
            :props="props"
            class="cursor-pointer"
            @click.native="$router.push({ path: `/places/${props.row.id}` })"
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
    </div>
  </q-page>
</template>

<script>
import { mapActions } from "vuex";
import { API } from "@/shared/config";

export default {
  name: "ItemsList",
  data() {
    return {
      filter: "",
      loading: true,
      pagination: {
        rowsPerPage: 10,
        sortBy: "toponym"
      },
      columns: [
        {
          name: "toponym",
          required: true,
          label: "Ortsname",
          align: "left",
          field: row => row.properties.name.toponym,
          sortable: true
        }
      ],
      data: []
    };
  },

  computed: {
    fullNameIndex() {
      return this.$store.getters.fullNameIndex;
    }
  },

  mounted() {
    this.getItems();
  },

  async beforeCreate() {
    if (this.$store.getters.fullNameIndex.length == 0) {
      await this.loadFullNameIndexAction();
    }
  },

  methods: {
    ...mapActions(["loadFullNameIndexAction"]),
    async getItems() {
      try {
        const response = await fetch(`${API}${this.$route.path}`);
        const data = await response.json();
        this.data = data;
        this.loading = false;
      } catch (error) {
        // eslint-disable-next-line
        console.error(error)
      }
    }
  }
};
</script>

<style></style>
