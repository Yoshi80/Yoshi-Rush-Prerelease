--Eclipse
--scripted by YoshiDuels
local s,id=GetID()
function s.initial_effect(c)
	-- Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.desfilter1(c,tp)
	return c:IsFaceup() and not c:IsMaximumModeSide() and Duel.IsExistingMatchingCard(s.desfilter2,tp,0,LOCATION_MZONE,1,nil,c:GetLevel())
end
function s.desfilter2(c,lv)
	return c:IsFaceup() and c:IsLevel(lv) and not c:IsMaximumModeSide()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,s.desfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	if tc then
		local dg=Duel.SelectMatchingCard(tp,s.desfilter2,tp,0,LOCATION_MZONE,1,1,nil,tc:GetLevel())
		if #dg>0 then
			dg:AddCard(tc)
			Duel.HintSelection(dg,true)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
