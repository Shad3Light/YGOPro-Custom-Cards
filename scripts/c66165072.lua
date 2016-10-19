-- The Legendary Golem Mini Stone Giant
function c66165072.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c66165072.spcon)
	c:RegisterEffect(e1)
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetValue(c66165072.sumlimit)
	c:RegisterEffect(e3)
	--double tribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e4:SetValue(c66165072.condition)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66165072,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,66165072)
	e5:SetCondition(c66165072.thcon)
	e5:SetTarget(c66165072.thtg)
	e5:SetOperation(c66165072.thop)
	c:RegisterEffect(e5)
end
function c66165072.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c66165072.sumlimit(e,c)
	return not c:IsSetCard(0xea010)
end
function c66165072.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xea010)
end
function c66165072.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c66165072.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c66165072.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SUMMON and c:GetReasonCard():IsSetCard(0xea010)
end
function c66165072.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xea010) and c:IsAbleToHand()
end
function c66165072.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c66165072.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66165072.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c66165072.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c66165072.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
