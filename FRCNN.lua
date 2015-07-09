local FRCNN = torch.class('nnf.FRCNN')

function FRCNN:__init(dataset)
  self.dataset = dataset
  
  self.scale = {600}
  self.max_dim = 1000
  self.randomscale = true
  
  --self.sz_conv_standard = 13
  self.step_standard = 16
  --self.offset0 = 21
  --self.offset = 6.5
  
  --self.inputArea = 224^2
 
end

local function rgb2bgr(I)
  local out = I.new():resizeAs(I)
  for i=1,I:size(1) do
    out[i] = I[I:size(1)+1-i]
  end
  return out
end

local function prepareImage(I,typ)
  local typ = typ or 1
  local mean_pix = typ == 1 and {128.,128.,128.} or {103.939, 116.779, 123.68}
  local I = I
  if I:dim() == 2 then
    I = I:view(1,I:size(1),I:size(2))
  end
  if I:size(1) == 1 then
    I = I:expand(3,I:size(2),I:size(3))
  end
  I = rgb2bgr(I):mul(255)
  for i=1,3 do
    I[i]:add(-mean_pix[i])
  end
  return I
end

function FRCNN:getScale(I)
  local min_size = math.min(I[2],I[3])
  local max_size = math.max(I[2],I[3])
  local scale
  if max_size <= self.max_dim then
    scale = self.scale[1]/min_size
  else
    scale = self.max_dim/max_size
  end
  return scale
end

function FRCNN:projectBBoxes(bboxes,scale)
  return (bboxes-1)*scale+1
end

function FRCNN:getFeatures(i,flip)
  local I = self.dataset:getImage(i)
  local bboxes = self.dataset:attachProposals(i)
  I = prepareImage(I)
  if flip then
    
  end
end
