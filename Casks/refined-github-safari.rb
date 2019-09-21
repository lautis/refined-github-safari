cask 'refined-github-safari' do
  version '2.0.15'
  sha256 '3f224d6ef2553d0435217012284055d19192583e40a7875a381290d9cce0562e'

  url "https://github.com/lautis/refined-github-safari/releases/download/v#{version}/Refined-GitHub-for-Safari.zip"
  appcast 'https://github.com/lautis/refined-github-safari/releases.atom'
  name 'refined-github-safari'
  homepage 'https://github.com/lautis/refined-github-safari'

  app 'Refined GitHub for Safari.app'

  zap delete: [
    '~/Library/Application Scripts/fi.lautanala.refined-github',
    '~/Library/Application Scripts/fi.lautanala.refined-github-extension',
    '~/Library/Containers/fi.lautanala.refined-github',
    '~/Library/Containers/fi.lautanala.refined-github-extenstion'
  ]
end
