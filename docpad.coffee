# DocPad Configuration File
# http://docpad.org/docs/config

languages = ['ru', 'en']

docpadConfig = {
    events:
        renderBefore: () ->

            # Rewrite `pages/` to the root and `posts/` to the `blog/`.
            this.docpad.getCollection('documents').forEach (page) ->
                newOutPath = page.get('outPath')
                    .replace('/out/pages/', '/out/')
                    .replace('/out/posts/', '/out/blog/')
                newUrl = page.get('url')
                    .replace('pages/', '')
                    .replace('posts/', 'blog/')
                page.set('outPath', newOutPath)
                page.setUrl(newUrl)

            # Rewrite `_ru` to the `/ru/`
            for language in languages
                this.docpad.getCollection(language + 'Documents').forEach (page) ->
                    newOutPath = page.get('outPath')
                        .replace('/out/', "/out/#{language}/")
                        .replace("_#{language}.", '.')
                    newUrl = '/' + language + page.get('url')
                        .replace("_#{language}.", '.')
                    page.set('outPath', newOutPath)
                    page.setUrl(newUrl)
    collections: {}
}

# Declare `ru` and `en` collections
for language in languages
    docpadConfig.collections[language + 'Documents'] = do (language) -> ->
        @getCollection("documents")
            .findAllLive({basename: ///_#{language}$///})

# Export the DocPad Configuration
module.exports = docpadConfig
