    # Export Plugin
    module.exports = (BasePlugin) ->
        # Define Plugin
        class LanguagesPlugin extends BasePlugin
            # Plugin name
            name: 'languages'

            # Render some content synchronously
            renderBefore: (opts) ->
                docpad = @docpad
                languages = ['ru', 'en'] # Move to config of the plugin
                languageRegex = ///^(.+?)_(#{languages.join('|')})$///
                docpad.getCollection('documents').findAllLive({basename: languageRegex}).forEach (document) ->
                    parts = document.attributes.basename.match(languageRegex)
                    language = parts[2]

                    newOutPath = document.get('outPath')
                        .replace('/out/', "/out/#{language}/")
                        .replace("_#{language}.", '.')
                    newUrl = '/' + language + document.get('url')
                        .replace("_#{language}.", '.')
                    document.set('outPath', newOutPath)
                    document.setUrl(newUrl)
                    # document.set('urls', [newUrl])
                    # And a lot of other attributes could be changed there?
