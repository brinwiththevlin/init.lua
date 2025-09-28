-- In your plugins configuration file (e.g., lua/plugins/image.lua)
return {
  "3rd/image.nvim",
  opts = {
    backend = "kitty",
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        show_remote_images = true,
      },
      neorg = {
        enabled = true,
      },
    },
    -- For transparent images
    kitty_window_id = vim.v.windowid,
    -- Max width and height of the image in the editor
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
  },
}
