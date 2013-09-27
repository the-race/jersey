Fabricator(:athlete) do
  totals { [Fabricate.build(:total)] }

  name   'Justin R.'
  number '1108047'
end
