<template>
  <div
    class="message-text__wrap">
    <template>
      {{ message }}
    </template>
    <button v-for="item in items" :key="item.type">
      class="text-slate-300 dark:text-slate-300 cursor-pointer text-xs py-1"
    >
      <span class="flex items-center gap-0.5">
        <fluent-icon icon="chevron-up" size="16" />
        {{ $t('CHAT_LIST.HIDE_QUOTED_TEXT') }}
      </span>
      <span class="flex items-center gap-0.5">
        <fluent-icon icon="chevron-down" size="16" />
        {{ $t('CHAT_LIST.SHOW_QUOTED_TEXT') }}
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
      items: [{type:"abc"}],
    }   
  },
  methods: {
      loadItems() {
        console.log(this.message);
        const { type } = JSON.parse(this.message);

        this.items.push({
          type: type
        });

        this.items.push({
          type: "list"
        });
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
