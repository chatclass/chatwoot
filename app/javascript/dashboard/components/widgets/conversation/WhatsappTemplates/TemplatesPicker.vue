<template>
  <div class="w-full">
    <div class="templates__list-search gap-1">
      <fluent-icon icon="search" class="search-icon" size="16" />
      <input
        ref="search"
        v-model="query"
        type="search"
        :placeholder="$t('WHATSAPP_TEMPLATES.PICKER.SEARCH_PLACEHOLDER')"
        class="templates__search-input"
      />
    </div>
    <div class="template__list-container">
      <div v-for="(template, i) in filteredTemplateMessages" :key="template.id">
        <button
          class="template__list-item"
          @click="$emit('onSelect', template)"
        >
          <div>
            <div class="flex items-center justify-between mb-2.5">
              <p class="label-title">
                {{ template.name }}
              </p>
              <span
                class="inline-block py-1 px-2 rounded-sm text-xs leading-none cursor-default bg-white dark:bg-slate-700 text-slate-800 dark:text-slate-100"
              >
                {{ $t('WHATSAPP_TEMPLATES.PICKER.LABELS.LANGUAGE') }} :
                {{ template.language }}                                
              </span>
            </div>
            <div>
              <p class="strong">
                {{ $t('WHATSAPP_TEMPLATES.PICKER.LABELS.TEMPLATE_BODY') }}
              </p>
              <p class="label-body">{{ getTemplatebody(template) }}</p>
            </div>
            <div class="label-category">
              <p class="strong">
                {{ $t('WHATSAPP_TEMPLATES.PICKER.LABELS.CATEGORY') }}
              </p>
              <p>
                {{ template.category }}
                <span class="inline-block rounded-sm text-xs delete-template leading-none cursor-default">
                  <button type="button" @click.stop="deleteTemplate(template)" class="button smooth button--only-icon small alert has-tooltip delete-template-button"><svg width="14" height="14" fill="none" viewBox="0 0 24 24" class="icon icon--font delete"><path d="M12 1.75a3.25 3.25 0 0 1 3.245 3.066L15.25 5h5.25a.75.75 0 0 1 .102 1.493L20.5 6.5h-.796l-1.28 13.02a2.75 2.75 0 0 1-2.561 2.474l-.176.006H8.313a2.75 2.75 0 0 1-2.714-2.307l-.023-.174L4.295 6.5H3.5a.75.75 0 0 1-.743-.648L2.75 5.75a.75.75 0 0 1 .648-.743L3.5 5h5.25A3.25 3.25 0 0 1 12 1.75Zm6.197 4.75H5.802l1.267 12.872a1.25 1.25 0 0 0 1.117 1.122l.127.006h7.374c.6 0 1.109-.425 1.225-1.002l.02-.126L18.196 6.5ZM13.75 9.25a.75.75 0 0 1 .743.648L14.5 10v7a.75.75 0 0 1-1.493.102L13 17v-7a.75.75 0 0 1 .75-.75Zm-3.5 0a.75.75 0 0 1 .743.648L11 10v7a.75.75 0 0 1-1.493.102L9.5 17v-7a.75.75 0 0 1 .75-.75Zm1.75-6a1.75 1.75 0 0 0-1.744 1.606L10.25 5h3.5A1.75 1.75 0 0 0 12 3.25Z" fill="currentColor"></path></svg> <!----></button>
                </span>              
              </p>              
            </div>
          </div>
        </button>
        <hr v-if="i != filteredTemplateMessages.length - 1" :key="`hr-${i}`" />
      </div>
      <div v-if="!filteredTemplateMessages.length">
        <p>
          {{ $t('WHATSAPP_TEMPLATES.PICKER.NO_TEMPLATES_FOUND') }}
          <strong>{{ query }}</strong>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
// TODO: Remove this when we support all formats
const formatsToRemove = ['DOCUMENT', 'IMAGE', 'VIDEO'];

export default {
  props: {
    inboxId: {
      type: Number,
      default: undefined,
    },
  },
  data() {
    return {
      query: '',
    };
  },
  computed: {
    whatsAppTemplateMessages() {
      // TODO: Remove the last filter when we support all formats
      return this.$store.getters['inboxes/getWhatsAppTemplates'](this.inboxId)
        .filter(template => template.status.toLowerCase() === 'approved')
        .filter(template => {
          return template.components.every(component => {
            return !formatsToRemove.includes(component.format);
          });
        });
    },
    filteredTemplateMessages() {
      let templatesIds = JSON.parse(localStorage.getItem("templatesIds")); 

      const filtered = this.whatsAppTemplateMessages.filter(template =>
        template.name.toLowerCase().includes(this.query.toLowerCase()) && !templatesIds?.includes(template.id)
      );     

      return filtered;
    },
  },
  methods: {
    getTemplatebody(template) {
      return template.components.find(component => component.type === 'BODY')
        .text;
    },
    deleteTemplate(template) {      
      if (confirm("Tem certeza que deseja deletar?")) {        
        let templatesIds = [];

        if (localStorage.getItem("templatesIds"))
          templatesIds = JSON.parse(localStorage.getItem("templatesIds"));        

        templatesIds.push(template.id);
        localStorage.setItem("templatesIds", JSON.stringify(templatesIds));

        this.filteredTemplateMessages();
      }
    },
  },
};
</script>

<style scoped lang="scss">
.templates__list-search {
  @apply items-center flex bg-slate-25 dark:bg-slate-900 mb-2.5 py-0 px-2.5 rounded-md border border-solid border-slate-100 dark:border-slate-700;

  .search-icon {
    @apply text-slate-400 dark:text-slate-300;
  }

  .templates__search-input {
    @apply bg-transparent border-0 text-xs h-9 m-0;
  }
}
.template__list-container {
  @apply bg-slate-25 dark:bg-slate-900 rounded-md max-h-[18.75rem] overflow-y-auto p-2.5;

  .template__list-item {
    @apply rounded-lg cursor-pointer block p-2.5 text-left w-full hover:bg-woot-50 dark:hover:bg-slate-800;

    .label-title {
      @apply text-sm;
    }

    .label-category {
      @apply mt-5;

      span {
        @apply text-sm font-semibold;
      }
    }

    .label-body {
      font-family: monospace;
    }
  }
}

.strong {
  @apply text-xs font-semibold;
}

.delete-template{
  width: 100% !important;  
  text-align: right;    
}

.delete-template-button{  
  margin-top: -70px;
}

hr {
  @apply border-b border-solid border-slate-100 dark:border-slate-700 my-2.5 mx-auto max-w-[95%];
}
</style>
