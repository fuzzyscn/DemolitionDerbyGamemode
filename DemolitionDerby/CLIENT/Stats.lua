wins = GetResourceKvpInt('dd:wins');losses =  GetResourceKvpInt('dd:losses');kills =  GetResourceKvpInt('dd:kills'); tempWins = 0; targetWins = 0

function AddWin(amount)     
    SetResourceKvpInt('dd:wins', GetResourceKvpInt('dd:wins') + 1) 
    wins = GetResourceKvpInt('dd:wins')
end

function AddLoss(amount)
    SetResourceKvpInt('dd:losses', GetResourceKvpInt('dd:losses') + 1) 
    wins = GetResourceKvpInt('dd:losses')
end