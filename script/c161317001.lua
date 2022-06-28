--Voidvelgr Elysium
--scripted by YoshiDuels
local s,id=GetID()
function s.initial_effect(c)
	--change position
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function s.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsCanChangePositionRush()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--cost
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.SendtoGrave(g,REASON_COST)>0 then
		--Effect
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=Duel.SelectMatchingCard(tp,s.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(sg)
		if #sg>0 then
			Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
			--Effect
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local tc=g:GetFirst()
			if tc:IsType(TYPE_MONSTER) and tc:IsLocation(LOCATION_GRAVE) then
				Duel.BreakEffect()
				--Cannot be destroyed by opponent's trap
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(3012)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e2:SetValue(s.efilter)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e2)
			end
		end
	end
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()==1-e:GetHandlerPlayer()
end