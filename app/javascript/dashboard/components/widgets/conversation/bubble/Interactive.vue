<template>
  <div
    class="message-text__wrap">
    <template>
      {{ message }}
    </template>
    <button v-for="button in buttons" :key="item.type" class="button default resolve">
      <span class="flex items-center gap-0.5">
        <fluent-icon icon="chevron-up" size="16" />
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
      buttons: [],
      list: [],
    }   
  },
  methods: {
      loadItems() {
        const contentJson = this.message?.replaceAll("=>", ":").replaceAll("“","\"").replaceAll("”","\"");
        const content = JSON.parse(contentJson);
        const { type } = content;

        if (type == "button")
        {
            const { actions: { buttons } } = content;

            buttons.push(buttons);
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
