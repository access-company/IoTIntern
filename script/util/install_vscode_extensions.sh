#!/bin/sh
set -euo

install_extension(){
  # The url of an extension in the market place is like:
  #  https://marketplace.visualstudio.com/items?itemName=${publisher}.${extension_name}
  # The version of the extension can be browsed in the page.
  publisher="$1"
  extension_name="$2"
  version="$3"

  download_url="https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${extension_name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"

  wget "$download_url" -O "${extension_name}.VSIX"
  code --install-extension "${extension_name}.VSIX"
  rm "${extension_name}.VSIX"
}

# https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml
install_extension jebbs plantuml 2.15.1

# https://marketplace.visualstudio.com/items?itemName=develiteio.api-blueprint-viewer
install_extension develiteio api-blueprint-viewer 0.9.4

# https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph
install_extension mhutchie git-graph 1.30.0

# https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls
# If version of the Erlang required by antikythera <= 20, version of the elixir-ls should be <= 0.5.0
install_extension JakeBecker elixir-ls 0.5.0
