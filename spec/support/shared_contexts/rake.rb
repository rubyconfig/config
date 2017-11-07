shared_context 'rake' do

  # include rails rake tasks
  before do
    require 'rake'
    load 'rails/tasks/engine.rake'
  end

end
