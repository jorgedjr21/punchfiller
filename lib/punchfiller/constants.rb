module Constants
  ROWS = {
    'Quando ▼'        => :date,
    'Horário inicial' => :start_time,
    'Até'             => :end_time,
    'Delta'           => :delta,
    'Hora extra?'     => :extra_work,
    'Projeto'         => :project
  }

  PUNCHLOCK_URL = 'https://punchclock.cm42.io/'

  TIMES_TO_FILL = [['09:00', '12:00'], ['13:00', '18:00']]
end
