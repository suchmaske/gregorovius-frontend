<template>
  <q-page padding>
    <div class="q-pa-md">
      <q-table
        grid
        :data="data"
        :columns="columns"
        row-key="id"
        :filter="filter"
        :pagination.sync="pagination"
        :loading="loading"
        flat
      >
        <template v-slot:top-left>
          <q-input v-model="filter" borderless dense debounce="300" placeholder="Suche">
            <template v-slot:append>
              <q-icon name="search" />
            </template>
          </q-input>
        </template>

        <template v-slot:item="props">
          <div class="q-pa-xs col-xs-12 col-sm-6 col-md-4 col-lg-3">
            <q-card>
              <q-separator />
              <q-list>
                <q-item
                  class="cursor-pointer"
                  @click.native="$router.push({ path: `/persons/${props.row.id}` })"
                >
                  <q-item-section>
                    <q-item-label>{{ fullNameIndex[props.row.id] }}</q-item-label>
                  </q-item-section>
                  <q-chip
                    size="12px"
                    :color="props.row.properties.type === 'org' ? 'blue-1' : 'orange-1'"
                  >
                    {{ props.row.properties.type | formatPersonType }}
                  </q-chip>
                </q-item>
              </q-list>
            </q-card>
          </div>
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
  filters: {
    formatPersonType(rawType) {
      if (rawType === "org") {
        return "Körperschaft";
      }
      if (rawType === "person") {
        return "Person";
      }
      return rawType;
    }
  },
  data() {
    return {
      filter: "",
      loading: true,
      pagination: {
        rowsPerPage: 50,
        sortBy: "name"
      },
      columns: [
        {
          name: "name",
          required: true,
          label: "Name",
          align: "left",
          field: row => this.fullNameIndex[row.id],
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

  async mounted() {
    if (this.$store.getters.fullNameIndex.length == 0) {
      await this.loadFullNameIndexAction();
    }
    this.getItems();
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
    },
    formatName(name) {
      if (name.surname && name.forename) {
        return `${name.forename} ${name.surname}`;
      }
      if (name.forename) {
        return name.forename;
      }
      if (name.surname) {
        return name.surname;
      }
      if (name.simpleName) {
        return name.simpleName;
      }
      if (name.roleName && name.simpleName) {
        return `${name.simpleName}, ${name.roleName}`;
      }
      if (name.roleName && name.forename) {
        return `${name.forename}, ${name.roleName}`;
      }
      if (name.orgName) {
        return name.orgName;
      }
      return "NN";
    }
  }
};
</script>

<style></style>
