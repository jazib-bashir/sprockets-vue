# sprockets-vue

[![Gem](https://img.shields.io/gem/v/sprockets-vue.svg)](https://rubygems.org/gems/sprockets-vue)
[![Gem](https://img.shields.io/gem/dt/sprockets-vue.svg)](https://rubygems.org/gems/sprockets-vue)

A [Sprockets](https://github.com/rails/sprockets) transformer that converts .vue file into js object.


# heads up!
version 0.0.6 has incompatible change, due to bugs in previous version.

now you should assign `vm` variable to make it works!

# feature

following tag is supported in .vue file
* script (currently coffeescript only)
* template (currently html only)
* style (scss, sass and css)

# install
add `gem 'sprockets-vue'` to Gemfile, and run bundle, currently works with sprockets 3.

# example
* index.vue
```vue
//= require compents/card
<script lang="coffee">
vm = {
  data: ->
    search: ''
    members: []
  components:
    card: VCompents['compents/card']
  methods:
    clear: ->
      this.search = ''
}
</script>

<template>
  <div class="container">
    <div class='search icon-input'>
      <span class="search-icon glyphicon glyphicon-search"></span>
      <input class="form-control" type="text" v-model='search'>
      <span @click='clear' class="clear-icon glyphicon glyphicon-remove"></span>
    </div>
    <card v-for="m in members" :m='m'></card>
  </div>
</template>

<style lang="scss">
.search{
  .icon-input{
    width: 100%;
  }
}
</style>
```

* application.coffee

```coffee
#= require index

new Vue(
  el: '#search',
  components: {
    'index': VCompents.index
  }
)
```

* application.scss
```scss
//=require index
```

> you can include .vue file in css file, it's style block will be automatic processed.
 you can also use `require_tree` to include all .vue file.😘
 `scoped` will not be supported. 

# advanced
* [multi file component](https://github.com/kikyous/sprockets-vue/wiki/multi-file-component)
