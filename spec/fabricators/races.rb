Fabricator(:race) do
  athletes { [Fabricate.build(:athlete)] }

  name  'Tour de France'
  slug  'tour-de-france'
end
