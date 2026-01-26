return {
    'nvim-mini/mini.nvim',
    version = '*',
    config = function()
        require('mini.ai').setup()
        require('mini.icons').setup()
    end
}