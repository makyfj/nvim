return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  opts = {
    provider = 'claude',
    windows = {
      width = 40,
    },
    vendors = {
      deepseek = {
        endpoint = 'https://api.deepseek.com/chat/completions',
        model = 'deepseek-coder',
        api_key_name = 'DEEPSEEK_API_KEY',
        parse_curl_args = function(opts, code_opts)
          return {
            url = opts.endpoint,
            headers = {
              ['Accept'] = 'application/json',
              ['Content-Type'] = 'application/json',
              ['Authorization'] = 'Bearer ' .. os.getenv(opts.api_key_name),
            },
            body = {
              model = opts.model,
              messages = { -- you can make your own message, but this is very advanced
                { role = 'system', content = code_opts.system_prompt },
                { role = 'user', content = require('avante.providers.openai').get_user_message(code_opts) },
              },
              temperature = 0,
              max_tokens = 4096,
              stream = true, -- this will be set by default.
            },
          }
        end,
        parse_response_data = function(data_stream, event_state, opts)
          require('avante.providers').openai.parse_response(data_stream, event_state, opts)
        end,
      },
      ---@type AvanteProvider
      groq = {
        endpoint = 'https://api.groq.com/openai/v1/chat/completions',
        model = 'llama-3.1-70b-versatile',
        api_key_name = 'GROQ_API_KEY',
        --- this function below will be used to parse in cURL arguments.
        parse_curl_args = function(opts, code_opts)
          return {
            url = opts.endpoint,
            headers = {
              ['Accept'] = 'application/json',
              ['Content-Type'] = 'application/json',
              ['Authorization'] = 'Bearer ' .. os.getenv(opts.api_key_name),
            },
            body = {
              model = opts.model,
              messages = require('avante.providers').openai.parse_message(code_opts), -- you can make your own message, but this is very advanced
              temperature = 0,
              max_tokens = 2048,
              stream = true, -- this will be set by default.
            },
          }
        end,
        -- The below function is used if the vendors has specific SSE spec that is not claude or openai.
        parse_response_data = function(data_stream, event_state, opts)
          require('avante.providers').openai.parse_response(data_stream, event_state, opts)
        end,
      },
      ---@type AvanteProvider
      cerebras = {
        endpoint = 'https://api.cerebras.ai/v1/chat/completions',
        model = 'llama3.1-70b',
        api_key_name = 'CEREBRAS_API_KEY',
        --- this function below will be used to parse in cURL arguments.
        parse_curl_args = function(opts, code_opts)
          return {
            url = opts.endpoint,
            headers = {
              ['Accept'] = 'application/json',
              ['Content-Type'] = 'application/json',
              ['Authorization'] = 'Bearer ' .. os.getenv(opts.api_key_name),
            },
            body = {
              model = opts.model,
              messages = require('avante.providers').openai.parse_message(code_opts), -- you can make your own message, but this is very advanced
              temperature = 0,
              max_tokens = 8192,
              stream = true, -- this will be set by default.
            },
          }
        end,
        -- The below function is used if the vendors has specific SSE spec that is not claude or openai.
        parse_response_data = function(data_stream, event_state, opts)
          require('avante.providers').openai.parse_response(data_stream, event_state, opts)
        end,
      },
    },
  },
  build = 'make',
  dependencies = {
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
        },
      },
    },
    {
      -- Make sure to setup it properly if you have lazy=true
      'OXY2DEV/markview.nvim',
      enabled = true,
      lazy = false,
      ft = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
      opts = {
        filetypes = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
        buf_ignore = {},
        max_length = 99999,
      },
    },
  },
}
