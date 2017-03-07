//
//  QuadTree.h
//  QuadTree
//
//  Created by Aaron Dean Bikis on 3/1/17.
//  Copyright © 2017 7apps. All rights reserved.
//

#ifndef QuadTree_h
#define QuadTree_h

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

typedef struct QuadTreeNodeData {
    double x;
    double y;
    void* data;
} QuadTreeNodeData;

QuadTreeNodeData QuadTreeNodeDataMake(double x, double y, void* data);

typedef struct BoundingBox {
    double x0; double y0;
    double xf; double yf;
} BoundingBox;
BoundingBox BoundingBoxMake(double x0, double y0, double xf, double yf);

typedef struct quadTreeNode {
    struct quadTreeNode* northWest;
    struct quadTreeNode* northEast;
    struct quadTreeNode* southWest;
    struct quadTreeNode* southEast;
    BoundingBox boundary;
    QuadTreeNodeData *points;
    int count;
    int bucketCapacity;
} QuadTreeNode;
QuadTreeNode* QuadTreeNodeMake(BoundingBox boundary, int bucketCapacity);

void FreeQuadTreeNode(QuadTreeNode* node);
typedef void(^QuadTreeTraverseBlock)(QuadTreeNode* currentNode);
typedef void(^DataReturnBlock)(QuadTreeNodeData data);
void QuadTreeGatherDataInRange(QuadTreeNode* node, BoundingBox range, DataReturnBlock block);

bool QuadTreeNodeInsertData(QuadTreeNode* node, QuadTreeNodeData data);
QuadTreeNode* QuadTreeBuildWithData(QuadTreeNodeData *data, int count, BoundingBox boundingBox, int capacity);

#endif /* QuadTree_h */
