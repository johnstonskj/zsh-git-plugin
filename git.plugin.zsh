# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name git
# @brief Set the path to the Git installed via Homebrew.
# @repository https://github.com/johnstonskj/zsh-git-plugin
# @version 0.1.1
# @license MIT AND Apache-2.0
#

###################################################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

#
# @description Initialize the plugin; specifically, add the Homebrew version of `git` to `$PATH`.
#
# @noargs
#
git_plugin_init() {
    builtin emulate -L zsh

    local git_path="$(homebrew_formula_prefix git)"
    if [[ -d "${git_path}" ]]; then
        @zplugins_add_to_path git "${git_path}/bin"
    else
        log_error "zsh-git: could not determine homebrew path for 'git'"
    fi
}
