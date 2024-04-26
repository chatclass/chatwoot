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
    <template>
      {{ text }}
    </template>
    <button v-for="button in buttons" class="button default block">
      <span class="flex items-center gap-0.5">
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

        if (type == "button")
        {
            const { action: { buttons } } = content;
            this.buttons = buttons;
        }
        else
        {

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
.text-content {
  overflow: auto;

  h1,
  h2,
  h3,
  h4,
  h5,
  h6 {
    font-size: var(--font-size-normal);
  }
},
button {
  background-color: #000;
  border: 1px solid black;
  margin-bottom:5px;
},
img {
  margin-bottom:5px;
}
</style>
