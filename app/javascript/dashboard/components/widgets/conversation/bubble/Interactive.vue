<template>
  <div
    class="message-text__wrap">
    <img
      v-if="hasHeader && isHeaderImage"
      class="bg-woot-200 dark:bg-woot-900"
      :src="header.image.link"
      width="auto"
      height="auto"
    />
    <div v-else-if="hasHeader && !isHeaderImage" class="interactive-header">
      {{ header.text }}
    </div>
    <div class="interactive-text">
      {{ text }}
    </div>
    <button v-for="button in buttons" class="button default block interactive-button">
      <span class="flex items-center gap-0.5 center">
        {{ button.reply.title }}
      </span>
    </button>
  </div>
</template>

<script>
import Letter from 'vue-letter';

export default {
  components: { Letter },
  props: {
    message: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      text: '',
      buttons: [],
      list: [],
      header: {}
    }   
  },
  methods: {
      loadItems() {
        const contentJson = this.message?.replaceAll("=>", ":").replaceAll("“","\"").replaceAll("”","\"");
        const content = JSON.parse(contentJson);
        const { type, header, body: { text } } = content;

        this.text = text;
        this.header = header;

        if (type === "button")
        {
            const { action: { buttons } } = content;
            this.buttons = buttons;
        }

        if (type === "list")
        {
            const { action: { button, sections } } = content;
            this.list = sections;
        }

      }
  },
  computed: {
    hasHeader() {
      return this.header != null;
    },
    isHeaderImage() {
      return this.header?.type === "image";
    },
  },
  mounted: function() {
    this.loadItems();
  }
};
</script>
<style lang="scss">
  .interactive-button {
    background-color: #4c5155 !important;
    margin-top:3px !important;
    text-align: center;
    width: 100%;
  }

  .interactive-header {
    display: block;
    font-weight: bold;
  }

  .interactive-text {
    font-weight: bold;
  }

  img {
    margin-bottom:7px !important;
  }
</style>
