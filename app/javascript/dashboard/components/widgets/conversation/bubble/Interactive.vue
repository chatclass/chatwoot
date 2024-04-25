<template>
  <div
    class="message-text__wrap">
    <template>
      {{ message }}
    </template>
    <template>
      {{ text }}
    </template>
    <button v-for="button in buttons" class="button default resolve">
      <span class="flex items-center gap-0.5">
        <fluent-icon icon="chevron-up" size="16" />
        {{ button[0].reply.title }}
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
    }   
  },
  methods: {
      loadItems() {
        const contentJson = this.message?.replaceAll("=>", ":").replaceAll("“","\"").replaceAll("”","\"");
        const content = JSON.parse(contentJson);
        const { type, body: { text } } = content;

        this.text = text;

        if (type == "button")
        {
            console.log(content);
            const { action: { buttons } } = content;
            console.log(buttons);
            this.buttons.push(buttons);
        }
        else
        {

        }
      }
  },
  mounted: function() {
    this.loadItems();
  }
};
</script>
<style lang="scss">
.text-content {
  overflow: auto;

  ul,
  ol {
    padding-left: var(--space-two);
  }

  table {
    margin: 0;
    border: 0;

    td {
      margin: 0;
      border: 0;
    }

    tr {
      border-bottom: 0 !important;
    }
  }

  h1,
  h2,
  h3,
  h4,
  h5,
  h6 {
    font-size: var(--font-size-normal);
  }
}
</style>
