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
                    parts = document.attributes.relativeBase.match(languageRegex)
                    initialName = parts[1]
                    language = parts[2]

                    addPrefixRegex = ///(#{initialName}_#{language})///
                    removePostfixRegex = ///(#{initialName})_#{language}///
                    replaceWithIndex = ///(#{initialName})\.html///

                    replacePath = (input) ->
                        input
                            .replace(addPrefixRegex, "#{language}/$1")
                            .replace(removePostfixRegex, "$1")
                            .replace(replaceWithIndex, "$1/index.html")

                    replaceAttibute = (attribute) ->
                        document.set attribute, replacePath document.get(attribute)

                    # Change urls
                    newUrl = replacePath document.get('url') + '/' # Could add `index.html` for really static env
                    document.setUrl(newUrl)
                    document.set('urls', [newUrl])

                    # Change rel dir path
                    document.set 'relativeOutDirPath', "#{language}/#{document.get('relativeOutDirPath')}"

                    # Change all the other stuff
                    replaceAttibute 'outPath'
                    replaceAttibute 'relativeOutPath'


                    # replaceAttibute 'outBasename'
                    # replaceAttibute 'relativeOutBase'

                    # document.set 'relativeOutBase', (document.get('relativeOutBase') + '/')
