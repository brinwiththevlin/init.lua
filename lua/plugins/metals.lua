-- Simple metals configuration that works with LazyVim scala extra
return {
  "scalameta/nvim-metals",
  ft = { "scala", "sbt" },
  opts = function(_, opts)
    -- Just add any custom settings you need
    -- LazyVim scala extra handles the main configuration
    local metals_config = opts or {}
    
    -- Add custom settings if needed
    metals_config.settings = metals_config.settings or {}
    metals_config.settings.showImplicitArguments = true
    metals_config.settings.showInferredType = true
    
    return metals_config
  end,
}