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
    <div v-if="isList">
      {{ listOption }}
    </div>
    <template v-if="isList" v-for="row in list">
      <input type="radio" :value="row.id" class="interactive-row">
      <label :for="row.id" class="interactive-label">{{ row.title }}</label><br>
    </template>
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
      listOption: '',
      header: {}
    }   
  },
  methods: {
      loadItems() {
        console.log(this.message);
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
            this.listOption = button;
            this.list = sections[0].rows;
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
    isList() {
      return this.list?.length > 0;
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

  .interactive-row {
    display: inline;
  }

  .interactive-label {
    display: inline;
    color: white;
  }

  img {
    margin-bottom:7px !important;
  }
</style>
