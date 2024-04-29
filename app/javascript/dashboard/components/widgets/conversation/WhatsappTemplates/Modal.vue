<!-- eslint-disable vue/no-mutating-props -->
<template>
  <woot-modal :show.sync="show" :on-close="onClose" size="modal-big">
    <woot-modal-header
      :header-title="$t('WHATSAPP_TEMPLATES.MODAL.TITLE')"
      :header-content="modalHeaderContent"
    />
    <div class="row modal-content">
      <templates-picker
        v-if="!selectedWaTemplate"
        :inbox-id="inboxId"
        @onSelect="pickTemplate"
      />
      <template-parser
        v-else
        :template="selectedWaTemplate"
        @resetTemplate="onResetTemplate"
        @sendMessage="onSendMessage"
      />
      <div class="right">
        <button type="submit" @click="newTemplate" class="button button--only-icon small primary has-tooltip">
          <svg data-v-3dcb4f04="" width="14" height="14" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" class="flex-shrink-0 icon icon--font whatsapp"><path d="M19.05 4.91A9.816 9.816 0 0 0 12.04 2c-5.46 0-9.91 4.45-9.91 9.91c0 1.75.46 3.45 1.32 4.95L2.05 22l5.25-1.38c1.45.79 3.08 1.21 4.74 1.21c5.46 0 9.91-4.45 9.91-9.91c0-2.65-1.03-5.14-2.9-7.01zm-7.01 15.24c-1.48 0-2.93-.4-4.2-1.15l-.3-.18l-3.12.82l.83-3.04l-.2-.31a8.264 8.264 0 0 1-1.26-4.38c0-4.54 3.7-8.24 8.24-8.24c2.2 0 4.27.86 5.82 2.42a8.183 8.183 0 0 1 2.41 5.83c.02 4.54-3.68 8.23-8.22 8.23zm4.52-6.16c-.25-.12-1.47-.72-1.69-.81c-.23-.08-.39-.12-.56.12c-.17.25-.64.81-.78.97c-.14.17-.29.19-.54.06c-.25-.12-1.05-.39-1.99-1.23c-.74-.66-1.23-1.47-1.38-1.72c-.14-.25-.02-.38.11-.51c.11-.11.25-.29.37-.43s.17-.25.25-.41c.08-.17.04-.31-.02-.43s-.56-1.34-.76-1.84c-.2-.48-.41-.42-.56-.43h-.48c-.17 0-.43.06-.66.31c-.22.25-.86.85-.86 2.07c0 1.22.89 2.4 1.01 2.56c.12.17 1.75 2.67 4.23 3.74c.59.26 1.05.41 1.41.52c.59.19 1.13.16 1.56.1c.48-.07 1.47-.6 1.67-1.18c.21-.58.21-1.07.14-1.18s-.22-.16-.47-.28z" fill="currentColor"></path></svg>Novo template
        </button>        
      </div>
    <div>    
  </woot-modal>
</template>

<script>
import TemplatesPicker from './TemplatesPicker.vue';
import TemplateParser from './TemplateParser.vue';
export default {
  components: {
    TemplatesPicker,
    TemplateParser,
  },
  props: {
    inboxId: {
      type: Number,
      default: undefined,
    },
    show: {
      type: Boolean,
      default: true,
    },
  },
  data() {
    return {
      selectedWaTemplate: null,
    };
  },
  computed: {
    modalHeaderContent() {
      return this.selectedWaTemplate
        ? this.$t('WHATSAPP_TEMPLATES.MODAL.TEMPLATE_SELECTED_SUBTITLE', {
            templateName: this.selectedWaTemplate.name,
          })
        : this.$t('WHATSAPP_TEMPLATES.MODAL.SUBTITLE');
    },
  },
  methods: {
    pickTemplate(template) {
      this.selectedWaTemplate = template;
    },
    onResetTemplate() {
      this.selectedWaTemplate = null;
    },
    onSendMessage(message) {
      this.$emit('on-send', message);
    },
    onClose() {
      this.$emit('cancel');
    },
    newTemplate(){
      window.open('https://app.chatclass.org/templates', '_blank', 'location=yes,height=570,width=520,scrollbars=yes,status=yes');
    }
  },
};
</script>

<style scoped>
.modal-content {
  padding: 1.5625rem 2rem;
}
</style>
