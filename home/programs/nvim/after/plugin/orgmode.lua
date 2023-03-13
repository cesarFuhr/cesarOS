local orgmode = require 'orgmode'

orgmode.setup {
  org_agenda_files = { '~/work/mine/orgs/*' },
  org_default_notes_file = '~/work/mine/orgs/notes.org',
}

orgmode.setup_ts_grammar()
