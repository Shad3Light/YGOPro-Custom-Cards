 --Created and coded by Rising Phoenix
function c100000991.initial_effect(c)
		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000991,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCost(c100000991.reccost)
	e1:SetTarget(c100000991.rectg)
	e1:SetOperation(c100000991.recop)
	c:RegisterEffect(e1)
end
function c100000991.filter1(c)
	return c:IsCode(41426869) and c:IsAbleToHand()
end
function c100000991.filter2(c)
	return c:IsCode(64631466) and c:IsAbleToHand()
end
function c100000991.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c100000991.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c100000991.filter1,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)
		and Duel.IsExistingTarget(c100000991.filter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c100000991.filter1,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c100000991.filter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c100000991.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end