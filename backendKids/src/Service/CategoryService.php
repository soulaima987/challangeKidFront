<?php

namespace App\Service;

use App\Entity\Category;

class CategoryService
{
    public function categoryToJson(Category $category)
    {
        return [
            'id' => $category->getId(),
            'title' => $category->getTitle(),
            'description' => $category->getDescription()
        ];
    }
}
