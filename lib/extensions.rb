require 'facets/kernel/blank'

# Can not use. It inteferes with active support underscore
# which is used by auto load! Such fun!
#
# See
#  * core/facets/string/underscore.rb
#  * core/facets/string/snakecase.rb
#
# Note, this method no longer converts `::` to `/`, in that case
# use the {#pathize} method instead.
#require 'facets/string/underscore'
