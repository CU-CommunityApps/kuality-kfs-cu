
include BatchUtilities

And /^Nightly Batch Jobs run$/ do
  # TODO: It would be nice to be able to switch back to the User
  #       that we were logged in as at the beginning of the batch
  #       jobs with out saying so explicitly.
  step 'I am logged in as a KFS Technical Administrator'
  step 'I run Nightly Out'
  step 'I run Scrubber'
  step 'I run Poster'
end

And /^I run (Nightly Out|Scrubber|Poster), not waiting for completion$/ do |action|
  
  case action
  when 'Nightly Out'
    run_nightly_out(false)
  when 'Scrubber'
    run_scrubber(false)
  when 'Poster'
    run_poster(false)
  end

end

And /^I run Nightly Out$/ do
  run_nightly_out(true)
end

And /^I run Scrubber$/ do
  run_scrubber(true)
end

And /^I run Poster$/ do
  run_poster(true)
end