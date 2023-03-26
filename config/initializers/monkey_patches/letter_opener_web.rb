#https://github.com/fgrehm/letter_opener_web/issues/42
if Rails.env.development?
  LetterOpenerWeb::Engine.routes.append do
    post 'clear' => 'letters#clear'
    post ':id' => 'letters#destroy'
  end
end
