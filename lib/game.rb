GRID = {'a1' => 0, 'b1' => 0, 'c1' => 0,
          'a2' => 0, 'b2' => 0, 'c2' => 0,
          'a3' => 0, 'b3' => 0, 'c3' => 0}

WIN_CONDITIONS = [
  ['a1', 'a2', 'a3'], #   vertical win 0
  ['b1', 'b2', 'b3'], #   vertical win 1
  ['c1', 'c2', 'c3'], #   vertical win 2
  ['a1', 'b1', 'c1'], # horizontal win 3
  ['a2', 'b2', 'c2'], # horizontal win 4
  ['a3', 'b3', 'c3'], # horizontal win 5
  ['a1', 'b2', 'c3'], #   diagonal win 6
  ['a3', 'b2', 'c1']  #   diagonal win 7
  ]


POSITION_REGEX         = /[abc][1-3]/
POSITION_REGEX_REVERSE = /[1-3][abc]/


