function c100000968.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100000968+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100000968.target)
	e1:SetOperation(c100000968.operation)
	e1:SetCost(c100000968.cost)
	c:RegisterEffect(e1)
end
function c100000968.cost(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x51,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x51,1,REASON_COST)
end
function c100000968.filter(c)
	return c:IsSetCard(0x115) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c100000968.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100000968.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3)
		and Duel.IsExistingTarget(c100000968.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100000968.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c100000968.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end
